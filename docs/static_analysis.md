# Flask Cloc API Static Analysis

## Created with [Semgrep](https://semgrep.dev/)

```
Findings:

  app.py 
     python.flask.security.audit.app-run-param-config.avoid_app_run_with_bad_host
        Running flask app with host 0.0.0.0 could expose the server publicly.


        151┆ app.run(host='0.0.0.0')
          ⋮┆----------------------------------------
     python.flask.security.audit.hardcoded-config.avoid_hardcoded_config_DEBUG
        Hardcoded variable `DEBUG` detected. Set this by using FLASK_DEBUG environment variable


        150┆ app.config["DEBUG"] = False
          ⋮┆----------------------------------------
     python.lang.security.audit.dangerous-subprocess-use.dangerous-subprocess-use
        Detected subprocess function 'run' without a static string. If this data can be controlled
        by a malicious actor, it may be an instance of command injection. Audit the use of this call
        to ensure it is not controllable by an external resource. You may consider using
        'shlex.escape()'.


         71┆ result = subprocess.run(
         72┆     args=["cloc", "-json", path], capture_output=True, text=True
         73┆ ).stdout
          ⋮┆----------------------------------------
         87┆ result = subprocess.run(
         88┆     args=["cloc", "-json", path], capture_output=True, text=True
         89┆ ).stdout

Some files were skipped.
  Scan was limited to files tracked by git.

Ran 242 rules on 1 file: 4 findings.
```
