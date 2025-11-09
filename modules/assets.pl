:- dynamic vuln/4. % vuln(Program, Asset, VulnType, Source).
:- dynamic tech/4. %  tech(Program, Asset, TechString, Source).

tech(highBounty, 'www.dropbox.com', envoy, katana) % TODO replace with real
vuln(highBounty, 'www.dropbox.com/file.php?file=INJECTION', lfi, expert) % incase of expert found vuln, expert will be the source
