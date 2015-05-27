# Script name: Functions
# Functions script library
# Remember:  ' $ ' (dollar sign), ' " ' (double-quote), and ' \ ' (backslash) must be escaped with preceding backslash '\' to when used in functions
# Function input array is passed from calling script using:
#   string:          ":local input \"<input1,input2,...>\"; "
#   command output: ":local input [/path/to/command get <item property>];"
# Function output array is stored in function's local $output variable
# Functions should always end with ; (semi-colon)   - this makes it easier when calling from another script
#
# Ex. To call MyFunc with input "1,2,3,4", storing function's output in global var MyOutput
#        From calling script:
# Code
#    /system script run "Functions"
#    :global MyFunc
#
#    :global MyOutput ""
#    :local runFunc [:parse (":global MyOutput;" . \
#             ":local input \"1,2,3,4\";" . \
#                       $MyFunc . \
#             ":set MyOutput \$output")
#         ]
#    $runFunc
# End Code
#
# The global variable $MyOutput now contains an array of output values from function
# To display output:
#    :put [:pick $MyOutput 0]
#    :put [:pick $MyOutput 1]
#    :put [:pick $MyOutput 2]
#    :put [:pick $MyOutput ...]


# Functions
#------------


# Prompt: Puts a prompt on the command line, then accepts an input from the user.
# Input array:
#   0 = prompt to display
#   1 = echo typed input (0 - default) or hide (1)
# Output array:
#   0 = input from user
:global Prompt ":local output \"\"
            :set input [:toarray \$input]
            :if ([:len \$input] > 0) do={
                :local input1 [:tostr [:pick \$input 0]]
                :local echo 0
                :if ([:len \$input] > 1) do={ 
                    :set echo [:tonum [:pick \$input 1]]
                }
                :local asciichar (\"0,1,2,3,4,5,6,7,8,9,\" . \
                                  \"a,b,c,d,e,f,g,h,i,j,k,l,\" . \
                                  \"m,n,o,p,q,r,s,t,u,v,w,x,y,z,\" . \
                                  \"A,B,C,D,E,F,G,H,I,J,K,L,\" . \
                                  \"M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,\" . \
                                  \".,/\")
                :local asciival {48;49;50;51;52;53;54;55;56;57; \
                                 97;98;99;100;101;102;103;104;105;106;107;108; \
                                 109;110;111;112;113;114;115;116;117;118;119;120;121;122; \
                                 65;66;67;68;69;70;71;72;73;74;75;76; \
                                 77;78;79;80;81;82;83;84;85;86;87;88;89;90; \
                                 46;47}
                
                :local findindex;
                :local loop 1;
                :local key 0;
                :put \"\$input1\";
                :while (\$loop = 1) do={
                
                    :set key ([:terminal inkey])
                    
                    :if (\$key = 8) do={
                        :set output [pick \$output 0 ([:len \$output] -1)];
                        :if (\$echo != 1) do={
                            :put \"\r\$output              \";
                            /terminal cuu 0;
                        } else={
                            :local stars;
                            :if ([:len \$output] > 0) do={
                                :for x from=0 to=([:len \$output]-1) do={
                                    :set stars (\$stars . \"*\");
                                }    
                            }
                            :put \"\r\$stars                         \";
                            /terminal cuu 0;
                        }
                    }
                    
                    :if (\$key = 13) do={
                        :set loop 0;
                        put \"\";
                        } else={
                           
#                       # Convert numeric ascii value to ascii character
                        :set findindex [:find [:toarray \$asciival] \$key]
                        :if ([:len \$findindex] > 0) do={
                            :set key [:pick [:toarray \$asciichar] \$findindex]
                            :set output (\$output . \$key);
                            :if (\$echo != 1) do={
                                :put \"\r\$output                \";
                                /terminal cuu 0;
                            } else={
                                :local stars;
                                :for x from=0 to=([:len \$output]-1) do={
                                    :set stars (\$stars . \"*\");
                                    }
                                                            
                                :put \"\r\$stars                     \";
                                /terminal cuu 0;
                            }
                        }
                    }
                }
                :set output [:toarray \$output]
            };"
                


# -----------------
# End Functions
