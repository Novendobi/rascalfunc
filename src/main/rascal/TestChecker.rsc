module TestChecker

extend Checker;
extend analysis::typepal::TestFramework;
import ParseTree;
import PYSyntax;

//implementing checker test
TModel pythonsyntaxTModelFromTree(Tree pt){
    return collectAndSolve(pt);
}

TModel pythonsyntaxTModelFromStr(str text){
    pt = parse(#start[Pystate], text);
    return pythonsyntaxTModelFromTree(pt);
}
        
test bool pythonsyntaxTests() {
    return runTests([|project://pythonsyntax/src/resources/tests.ttl|],
    #start[Pystate], pythonsyntaxTModelFromTree);
}
bool main() = pythonsyntaxTests();