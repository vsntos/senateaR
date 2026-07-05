## R CMD check results

0 errors | 0 warnings | 0 notes (see verification log for the exact run;
a single "New submission" NOTE is expected for a first-time CRAN
submission and is not a defect).

## Test environments

* local macOS install, R 4.5.1

## Notes for reviewers

* All exported functions retrieve data from live, third-party endpoints
  operated by the Argentine Senate (senado.gob.ar). Examples are wrapped
  in \dontrun{} because these endpoints are outside our control and not
  guaranteed to be reachable or stable during CRAN's automated checks.
  Tests that exercise live endpoints are skipped on CRAN via
  testthat::skip_on_cran() and testthat::skip_if_offline().
* This is a new submission.
