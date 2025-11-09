tool(bbot).
tool_output_file(bbot, 'bbot.json').

%% tool_def(+Tool, +CommandTemplate).
%  Command template uses placeholders:
%    {output_file}  -> path (file) where tool will write its output (json/xml)
%    {target}       -> the target (host/domain/url)
tool_produces(bbot_expert, [url, tech, host, domain, vuln, finding]).
tool_takes(bbot, url).
tool_takes(bbot, host).
tool_takes(bbot, domain).
tool_takes(bbot, wildcard).

tool_use(bbot, discovery).
tool_use(bbot, vuln).
tool_use(bbot, automation).

tool_def(bbot,
  ['bbot',
   '--output-dir', '{output_file}',
   '--output-modules', 'json',
   '-t', '{target}',
   '-p', 'subdomain-enum']
).
