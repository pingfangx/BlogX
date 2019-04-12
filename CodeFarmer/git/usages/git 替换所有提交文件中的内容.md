
[How to substitute text from files in git history?
](https://stackoverflow.com/questions/4110652)

    git filter-branch --tree-filter "find . -name '*.php' -exec sed -i -e 's/originalpassword/newpassword/g' {} \;"
    
    find 命令
    -exec command ;
     Execute command; true if 0 status is returned.  All following
              arguments to find are taken to be arguments to the command
              until an argument consisting of `;' is encountered.  The
              string `{}' is replaced by the current file name being
              processed everywhere it occurs in the arguments to the
              command, not just in arguments where it is alone, as in some
              versions of find.  Both of these constructions might need to
              be escaped (with a `\') or quoted to protect them from
              expansion by the shell. 
              
    sed 命令
     -i[SUFFIX], --in-place[=SUFFIX]

              edit files in place (makes backup if SUFFIX supplied)
      -e script, --expression=script

              add the script to the commands to be executed
    

最终执行
    
    git filter-branch --tree-filter "find . -name '*.kt' -o -name '*.java' -exec sed -i -e 's/find/replace/g' {} \;"