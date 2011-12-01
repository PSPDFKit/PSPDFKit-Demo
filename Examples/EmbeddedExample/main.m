//
//  main.m
//  EmbeddedExample
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

int main(int argc, char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
