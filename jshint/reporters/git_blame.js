"use strict";
var exec = require("child_process").exec;

module.exports = {
    reporter: function(errors, something, somethingElse, callback) {
        var processed = 0;
        var errorsByUser = {};
        var currentUser = "";

        var process = function() {
            var error = errors[processed].error;
            var offendingUser;

            var command = "git blame -L "+error.line+","+error.line+" "+errors[processed].file;

            exec(command, function(err, stdout, stderror) {
                offendingUser = stdout.match(/^[^(]+\(([A-Za-z ]+[^ 0-9])[ 0-9]/)[1];

                // If not committed yet, offending user is the current user
                if (offendingUser === 'Not Committed Yet' && currentUser) {
                    offendingUser = currentUser;
                }

                errorsByUser[offendingUser] = errorsByUser[offendingUser] || 0;
                errorsByUser[offendingUser]++;
                console.log([
                    errors[processed].file,
                    ": line ",
                    error.line,
                    ", col ",
                    error.character,
                    ", ",
                    error.reason.replace(/\.$/, ""),
                    ":\n>>",
                    error.evidence,
                    "\n(Committed by: ",
                    offendingUser,
                    ")\n"
                ].join(""));

                processed++;

                if (processed < errors.length) {
                    process();
                } else {
                    console.log("Offenders:");

                    var sorted = Object.keys(errorsByUser).sort(function(a, b) {
                        return errorsByUser[b] - errorsByUser[a];
                    });

                    for (var s = 0; s < sorted.length; s++) {
                        console.log(sorted[s]+":", errorsByUser[sorted[s]]);
                    }

                    callback();
                }
            });
        }

        if (errors.length) {
            // Get and store the current git user for resolving
            // 'Not Committed Yet'
            exec("git config user.name", function(error, stdout, stdin) {
                currentUser = stdout.replace(/\n$/, "");
                process();
            });
        } else {
            callback();
        }
    }
}
module.exports.reporter.async = true;
