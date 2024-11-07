# Usage

1. Get a Canvas token from https://bth.instructure.com/profile/settings.

Add the token to the environment variable CANVAS_TOKEN.


2. Run `$ bash grader.bash fetch` # get new data (prompts for canvas course id if not added)
3. Run `$ bash grader.bash print` # print the data with awk
4. Run `$ bash grader.bash table` # print the data with js (Not working 100%)

-----------------------------------------------------------
# Commands
```
Commands:
'init' (Use new coursecode)
'fetch' (Fetches new data from Canvas)
'save' (Saves the current result)
'print' (Prints current result)
'table' (Prints the result with js)
```
