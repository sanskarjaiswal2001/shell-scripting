#!/bin/bash

add=`expr $1 + $2`
sub=`expr $1 - $2`
mul=`expr $1 \* $2`
div=`expr $1 / $2`
echo "Addition of $1 and $2 is $add"
echo "Subtraction of $1 and $2 is $sub"
echo "Multiplication of $1 and $2 is $mul"
if [ $2 -eq 0 ]
then
echo "Division by zero is not possible"
else
echo "Division of $1 and $2 is $div"
fi