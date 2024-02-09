# Usage 

1. Create a file "course.data" and enter your course id.

For example:

course.data
```text
1234
```

2. Get a Canvas token from https://bth.instructure.com/profile/settings.

Add the token to the environment variable CANVAS_TOKEN.


3. Run `$ bash grader.bash fetch` # get new data
4. Run `$ bash grader.bash print` # print the data with awk
5. Run `$ bash grader.bash table` # print the data with js

-----------------------------------------------------------
```
Commands:
'init' (Use new coursecode)
'fetch' (Fetches new data from Canvas)
'save' (Saves the current result)
'print' (Prints current result)
'table' (Prints the result with js)
```
