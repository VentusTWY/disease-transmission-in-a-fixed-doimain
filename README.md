# Disease transmission in a fixed domain using MATLAB
MATLAB project to simulate transmission of disease in a fixed domain

A project inspired by COVID-19 Archive for Year 1 Computing Coursework, simulation of disease transmission in a population moving around in a fixed domain using MATLAB

RUN MAIN_DiseaseSim.m on MATLAB to start. Takes in a parameter n, as the number of individuals inside the fixed domain of 1000 units. (Suggested number would be 50-100) All individuals will be created with 'healthy' health status except for 1 'sick' individual.

The following conditions of disease transmissions were assumed:

When a healthy individual comes within 2 meters of a sick individual, there is a 50% chance of getting infected
When a healthy individual comes within 2 meters of an infected but asymptomatic indivdual, there is a 30% chance of getting infected.
Upon infection, there will be a 2 days incubation period prior to developing symptoms. During this period the individual will be identified as 'asymptomatic'
5 days after the initial infection, the individuals will recover fully.
The individuals are labelled as follows in the graphs: Healthy : Green Asymptomatic : Orange Sick : Red Recovered : Blue

The following graphs will be created by script to analyse the transmission:

A plot showing the location of individuals at the current time
A bar plot showing the total number of healthy, infected, sick and recovered individuals at the current time of simulation.
A line plot with history of healthy, infected, sick and recoverd individuals up to the current time.
The script will generate the following files:

InitialPlotDay0.jpeg - a file showing an initial plot of the population inside the domain
MultiPlotDay2.jpeg - a screenshot of all plots plots after 2 days
MultiPlotDay4.jpeg - a screenshot of all three plots after 4 days
MultiPlotDay6.jpeg - a screenshot of all three plots after 6 days
A text summary of total number of individuals with each health status at the end of each day will be printed out in the command line.
