:- use_module(library(sgml)).
:- use_module(library(xpath)).

tool(nmap).
tool_output_file(nmap, 'nmap.xml').
tool_produces(nmap, [services, port, host, domain, os]).

tool_use(nmap, discovery).
tool_use(nmap, port_scan).

tool_def(nmap,   ['-sV', '-oX', '{output_file}', '{target}']).
