/**
 * This is for mocking the console.log behavior. As on some browser (e.g.
 * webkit), the log is not fully logged to the file, instead, only the first
 * argument (i.e. the template) is logged.
 */


/** 
 * This will perform the substitutions converting the template to a single
 * string. 
 *
 * WARNING: this will not handle invalid type as console.log
 *
 * @param {string} template template string for substitutions
 * @param {any[]} args arguments
 * @returns {any[]} result
 *      first elements is the result string
 *      second elements is the list of argument that is not handled, this will
 *      also include objects in the `args`, so we can see object in inspector
 */
const formatTemplate = (template, ...args) => {

    // ref: https://developer.mozilla.org/en-US/docs/Web/API/console#using_string_substitutions
    const remainArgs = [];
    const formatted = template.replace(/%(?:\.([0-9]+)([idf])|([csoO]))/g, (match, len, numType, strType) => {
        const data = args.shift();
        if (data !== undefined) {
            switch (numType || strType) {
                case "d":
                case "i":
                    return String(data).padStart(len, '0');
                case "f":
                    return Number(data).toFixed(len);
                case "s":
                    return data;
                case "o":
                case "O":
                    remainArgs.push(data);
                    return JSON.stringify(data);
            }
            remainArgs.push(data);
        }
        return match;
    });

    return [formatted, remainArgs];
};

// examples
const createLogFunc = (func) => {
    return (__FILE__, __LINE__, template, ...args) => {
        const TAG = `[${__FILE__}:${__FILE__}]`;
        if (typeof template === "string") {
            if (args.length === 0) {
                func(`${TAG} ${template}`);
            }
            else {
                const [formatted, remainArgs] = formatTemplate(template, ...args);
                func(`${TAG} ${formatted}`, ...remainArgs);
            }
        }
    }
};

const Log = {
    v: createLogFunc(console.log),
};
