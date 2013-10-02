"use strict";
var exec = require("child_process").exec;

module.exports = {
    reporter: function(errors) {
        var processed = 0;
        var errorsByUser = {};

        var process = function() {
            var error = errors[processed].error;
            var offendingUser;

            var command = "git blame -L "+error.line+","+error.line+" "+errors[processed].file;

            exec(command, function(err, stdout, stderror) {
                offendingUser = stdout.match(/^[^(]+\(([A-Za-z ]+[^ 0-9])[ 0-9]/)[1];
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
                    Array.prototype.sort.call(errorsByUser, function(a, b) {
                        console.log(a, b);
                    });

                    for (var e in errorsByUser) {
                        if (errorsByUser.hasOwnProperty(e)) {
                            console.log(e, ":", errorsByUser[e]);
                        }
                    }
                }
            });
        }

        process();
    }
}
module.exports.reporter.async = true;
