# CONTRIBUTING

Anyone can contribute to BotZao. However, make sure to follow the code
guideline.

## CODE GUIDELINE

Starting simple, the following snippet is an `editorconfig` config file that
you can use or adapt to whatever mechanism you wish.

```
[*.{pl,pm}]
end_of_line = lf
insert_final_newline = true
charset = utf-8
trim_trailing_whitespaces = true
max_line_length = 80
wrap_width = 80
indent_style = tab
```

Also, as you may have noticed, this project is written in Perl, and Perl
community has a (not so hard)
[style guide](https://perldoc.perl.org/perlstyle). It must be followed.

## Git Workflow

We don't follow any too fancy git workflow. With that, the only requirement
I have is: base your changes on the `devel` branch; `master` is only used for
released code.
