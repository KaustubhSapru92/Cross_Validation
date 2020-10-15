# Cross_Validation
It's important to cross-validate to check or improve the accuracy of your model. It's obvious the the cross-validate functions exist in matlab and python libraries but to understand what really happens through each iteration of cross validation it should be implemented using first principles. Here I take an input signal and its corresponding output signal, which are obtained using a civil engineering experiment. A new output signal is synthesisized by convolving the input signal with an impulse where the order of the impulse is varied. This synthesisized signal is then compared with the output signal and the error is noted. 

Cross validation is then used to visualize the fluctuation in error as the order of the impulse progresses.
