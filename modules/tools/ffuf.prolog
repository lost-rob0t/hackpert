% ffuf.prolog — Fuzzing / content discovery
tool(ffuf).
tool_output_file(ffuf, 'ffuf.json').
tool_produces(ffuf, [url, status, length, word_count, fuzz_result]). % todo define these
tool_takes(ffuf, url).
tool_use(ffuf, fuzzing).
tool_phase(ffuf, fuzzing).
tool_def(ffuf,
  ['ffuf', '-u', '{target}/FUZZ', '-o', '{output_file}', '-w', '{wordlist_file}', '-f', 'json']
).
