snip_list.java = {
    sout = {'System.out.println($1);'},
    main = {'public void main() {','$1','}'},
    class = {'class $1 {','}'},
    pu = {'public '},
    pri = {'private '},
    pro = {'protected '},
    const = {'public static final '},
    f = {'for($1)'},
    i = {'if($1)'}
}

snip_list.c = {
    f = {'for($1)'},
    i = {'if($1)'},
    st = {'struct $1 {}'},
    main = {'int main(int argn, char *argv[]) {$1}'}
}
