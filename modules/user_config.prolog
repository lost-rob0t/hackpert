
user_config_dir("~/.config/hackmode-expert/")
user_config_file("~/.config/hackmode-expert/config.prolog").

load_user_config() :-
    user_config_file(Filepath),
    consult(Filepath).
