"use strict";

module.exports = {
    reporter: function(errors) {
        var processed = 0;
        var errorsByUser = {};

        errors.length && console.log(); // Blank line

        for (var e = 0; e < errors.length; e++) {
            var error = errors[e].error;

            console.log([
                errors[e].file,
                ": line ",
                error.line,
                ", col ",
                error.character,
                ", ",
                error.reason.replace(/\.$/, ""),
                ":\n>>",
                error.evidence,
                "\n"
            ].join(""));
        }

        if (errors.length) {
            console.log("Total errors:", errors.length, "\n");
        }
    }
}
