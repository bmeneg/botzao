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

As you may have noticed, this project is written in Perl, and Perl
community has a (not so hard)
[style guide](https://perldoc.perl.org/perlstyle). It must be followed.
Another really good source of information for Perl programming, with lots of
good practices is the
[Modern Perl book](http://modernperlbooks.com/books/modern_perl_2016/index.html),
which is a free and online book.

For this project we aren't using object-oriented programming, so, whenever 
possible, structured interfaces will be used rather then OO. Of course,
sometimes it's not possible, sometimes the dependency are all written in a
OO style, so we can't do much.

Another important information is: we don't use function prototypes, but
it's mandatory to use function signatures with each parameter called out.
It's possible by using the following snippet in every module:

```perl
use feature qw(signatures);
no warnings qw(experimental::signatures);
```

## Git Workflow

We don't follow any too fancy git workflow. With that, the only requirement
I have is: base your changes on the `devel` branch; `master` is only used for
released code.
