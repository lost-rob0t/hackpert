tool(katana).
tool_output_file(katana, 'katana.json').
tool_produces(katana, [url, tech, headers, title, status header]).

tool_takes(katana, url).
tool_takes(katana, domain).
tool_takes(katana, host).

tool_use(katana, discovery).

tool_def(katana, ['-fx',
                  '-td',
                  '-pc',
                  '-jc',
                  '-j',
                  '-jsl',
                  '-kf',
                  '--output', '{output_file}',
                  '--target', '{target}']).
