/*  Before we run any descriptive statistics or analysis, we need to create a data file.  Note, now when we create 
our data, we are using a count (or whatever we choose to name it) variable.  This variable indexes the frequency 
of occurrences(count) for each cell. Our variables here are whether someone had heart disease or not (1 or 0) 
and the level of snoring (0,2,4,5).

For every cell, such as no heart disease with level 4 snoring, we then give the counts. For example, 
there were 192 subjects that had no heart disease and were at level 4 snoring.  
Thus we enter 

heartdisease snoring count
      0         4     192

Normally, we would have a different row for each of the 192 subjects that had no heart disease and were at level 4 snoring. 
*/

data snoring; input heartdisease snoring count;
cards;
1 4 21
0  4 192
1 0 24
0 0 1355
1 2 35
0 2 603
1 5 30 
0 5 224
;
run;

/*
Linear Probability Model

To run categorical models, we will use proc genmod. Proc genmod can be used when the response variables
are categories. We can use it to model various distributions of the response as well.  
We will need to inform SAS what the distribution is as well as what link function to use.  

The link function is the transformation that is used on the mean of the response.  
For logistic regression, the link function is the logit.  
For a linear probability model, the link function is the identity function.  
Note, the identity function returns what is input into it. I(x) = x.  
For a linear probability model, we are modeling the mean itself and not a transformation of the mean, 
thus we use the identity function. 
The model is pie = a + � X.

The distribution is binomial.  This will always be the case when the response variable, 
here heart disease, takes the values 0 or 1 as categories.
Each trial is technically a Bernoulli trial but SAS requires us to enter binomial as the dsitribution.  
The binomial is the number of success out of n trials and is also an appropriate way of looking at it.  
Either way, we are interested in pie, the probability of success for a particular trial.

Here is the code:
*/

proc genmod data=snoring DESCENDING;
freq count;
model heartdisease =snoring/dist=bin link=identity;                                
run;

/*
When analyzing data formatted as we have it, we need to include the "freq" command which tells sas
which variable in our data set is the number of subjects per cell.

The model command tells SAS we are going to enter the model equation.  It follows the form
model Y = X.  

If there are more than 1 predictor variables, we use Model Y = X1 X2
If we wish to include the interactions, we use Y = X1 X2  X1*X2

After the model equation is given, we use a "/" then "dist" is for the distribution
and "link" is for the link function. 

The Descending at the top, tells SAS to model the probability that heartdisease = 1.  
The default is to model the probability that heartdisease = 0.
*/

/*
LOGISTIC MODELS

The code for the logistic models is the same as for the linear probability models, except now we are using the logit 
as the link function.  That is, we are modeling the log(odds) = a + � X. 
Again, we use the data set that has heart disease as categories, 0 or 1.
*/

proc genmod data=snoring DESCENDING;
freq count;
model heartdisease =snoring/dist=bin link=logit;      
output out=logresults p = pred_probs; 
run;

/*
To run the logistic regression with more than 1 predictor, both predictors go into the model statement. 
Suppose we want to include gender in the model equation, we could use

proc genmod data=snoring_with_gender DESCENDING;
freq count ;
model heartdisease =snoring gender/dist=bin link=logit;                                
run;

To include the interaction between gender and snoring, we use 

proc genmod data=snoring_with_gender DESCENDING;
freq count ;
model heartdisease =snoring gender snoring*gender/dist=bin link=logit;                                
run;
*/

/* We will now use the crab data to demonstrate how to plot the predicted probabilities, that is the S shaped curve.
We will use the same commands as before to run the logistic regression and similiar code
as with regression to plot the predicted values.
*/ 

data crab;
input  color spine  width  satell  weight;
if satell>0 then y=1; if satell=0 then y=0; n=1; 
weight = weight/1000;  color = color - 1;
if color=4 then dark=0; if color < 4 then dark=1;
cards;
3  3  28.3  8  3050
4  3  22.5  0  1550
2  1  26.0  9  2300
4  3  24.8  0  2100
4  3  26.0  4  2600
3  3  23.8  0  2100
2  1  26.5  0  2350
4  2  24.7  0  1900
3  1  23.7  0  1950
4  3  25.6  0  2150
4  3  24.3  0  2150
3  3  25.8  0  2650
3  3  28.2  11 3050
5  2  21.0  0  1850
3  1  26.0  14  2300
2  1  27.1  8  2950
3  3  25.2  1  2000
3  3  29.0  1  3000
5  3  24.7  0  2200
3  3  27.4  5  2700
3  2  23.2  4  1950
2  2  25.0  3  2300
3  1  22.5  1  1600
4  3  26.7  2  2600
5  3  25.8  3  2000
5  3  26.2  0  1300
3  3  28.7  3  3150
3  1  26.8  5  2700
5  3  27.5  0  2600
3  3  24.9  0  2100
2  1  29.3  4  3200
2  3  25.8  0  2600
3  2  25.7  0  2000
3  1  25.7  8  2000
3  1  26.7  5  2700
5  3  23.7  0  1850
3  3  26.8  0  2650
3  3  27.5  6  3150
5  3  23.4  0  1900
3  3  27.9  6  2800
4  3  27.5  3  3100
2  1  26.1  5  2800
2  1  27.7  6  2500
3  1  30.0  5  3300
4  1  28.5  9  3250
4  3  28.9  4  2800
3  3  28.2  6  2600
3  3  25.0  4  2100
3  3  28.5  3  3000
3  1  30.3  3  3600
5  3  24.7  5  2100
3  3  27.7  5  2900
2  1  27.4  6  2700
3  3  22.9  4  1600
3  1  25.7  5  2000
3  3  28.3  15  3000
3  3  27.2  3  2700
4  3  26.2  3  2300
3  1  27.8  0  2750
5  3  25.5  0  2250
4  3  27.1  0  2550
4  3  24.5  5  2050
4  1  27.0  3  2450
3  3  26.0  5  2150
3  3  28.0  1  2800
3  3  30.0  8  3050
3  3  29.0  10 3200
3  3  26.2  0  2400
3  1  26.5  0  1300
3  3  26.2  3  2400
4  3  25.6  7  2800
4  3  23.0  1  1650
4  3  23.0  0  1800
3  3  25.4  6  2250
4  3  24.2  0  1900
3  2  22.9  0  1600
4  2  26.0  3  2200
3  3  25.4  4  2250
4  3  25.7  0  1200
3  3  25.1  5  2100
4  2  24.5  0  2250
5  3  27.5  0  2900
4  3  23.1  0  1650
4  1  25.9  4  2550
3  3  25.8  0  2300
5  3  27.0  3  2250
3  3  28.5  0  3050
5  1  25.5  0  2750
5  3  23.5  0  1900
3  2  24.0  0  1700
3  1  29.7  5  3850
3  1  26.8  0  2550
5  3  26.7  0  2450
3  1  28.7  0  3200
4  3  23.1  0  1550
3  1  29.0  1  2800
4  3  25.5  0  2250
4  3  26.5  1  1967
4  3  24.5  1  2200
4  3  28.5  1  3000
3  3  28.2  1  2867
3  3  24.5  1  1600
3  3  27.5  1  2550
3  2  24.7  4  2550
3  1  25.2  1  2000
4  3  27.3  1  2900
3  3  26.3  1  2400
3  3  29.0  1  3100
3  3  25.3  2  1900
3  3  26.5  4  2300
3  3  27.8  3  3250
3  3  27.0  6  2500
4  3  25.7  0  2100
3  3  25.0  2  2100
3  3  31.9  2  3325
5  3  23.7  0  1800
5  3  29.3  12  3225
4  3  22.0  0  1400
3  3  25.0  5  2400
4  3  27.0  6  2500
4  3  23.8  6  1800
2  1  30.2  2  3275
4  3  26.2  0  2225
3  3  24.2  2  1650
3  3  27.4  3  2900
3  2  25.4  0  2300
4  3  28.4  3  3200
5  3  22.5  4  1475
3  3  26.2  2  2025
3  1  24.9  6  2300
2  2  24.5  6  1950
3  3  25.1  0  1800
3  1  28.0  4  2900
5  3  25.8  10 2250
3  3  27.9  7  3050
3  3  24.9  0  2200
3  1  28.4  5  3100
4  3  27.2  5  2400
3  2  25.0  6  2250
3  3  27.5  6  2625
3  1  33.5  7  5200
3  3  30.5  3  3325
4  3  29.0  3  2925
3  1  24.3  0  2000
3  3  25.8  0  2400
5  3  25.0  8  2100
3  1  31.7  4  3725
3  3  29.5  4  3025
4  3  24.0  10 1900
3  3  30.0  9  3000
3  3  27.6  4  2850
3  3  26.2  0  2300
3  1  23.1  0  2000
3  1  22.9  0  1600
5  3  24.5  0  1900
3  3  24.7  4  1950
3  3  28.3  0  3200
3  3  23.9  2  1850
4  3  23.8  0  1800
4  2  29.8  4  3500
3  3  26.5  4  2350
3  3  26.0  3  2275
3  3  28.2  8  3050
5  3  25.7  0  2150
3  3  26.5  7  2750
3  3  25.8  0  2200
4  3  24.1  0  1800
4  3  26.2  2  2175
4  3  26.1  3  2750
4  3  29.0  4  3275
2  1  28.0  0  2625
5  3  27.0  0  2625
3  2  24.5  0  2000
; 
run;

proc genmod data=crab descending;
model y =  width / dist=bin link=logit;
output out=logresults p = pred_probs;  
run;

/* Note, here we need to sort the x variable.  SAS creates the plot in the order the observations
are listed.  If we don't start from smallest to largest, the plot will be a bunch a lines going back and forth
*/

proc sort data=logresults; by width; run;

symbol1 i = join v=point l=32  c = black;
PROC GPLOT DATA=logresults;
PLOT  pred_probs*width;
RUN;

/* To run a poisson regression, the distribution is Poisson and the link is log.  Note here the response is the count
of satellites, which is labeled with the variable satell.  

With the logistic,the response was whether or not the crabs had a satellite, which was labeled y
and took the values 1 or 0.  */

proc genmod data=crab  ; 
model satell = width / dist=poi link=log;
output out=results_pois p =predicted_number_sat pred=re; ; 
run;