% whatweb.prolog — Web technology fingerprinting

:- dynamic tool/1, tool_output_file/2, tool_produces/2, tool_takes/2, tool_def/2, tool_use/2.

tool(whatweb).
tool_output_file(whatweb, 'whatweb.json').
tool_produces(whatweb, [host, tech, headers, cms]).
tool_takes(whatweb, host).
tool_takes(whatweb, url).
tool_takes(whatweb, domain).
tool_use(whatweb, fingerprint).

tool_def(whatweb, ['whatweb', '-a', '3', '-v', '--log-json', '{output_file}', '{target}']). % JSON output
