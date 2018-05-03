/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   a.cpp                                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: mikim <mikim@student.42.us.org>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2018/05/01 10:25:10 by mikim             #+#    #+#             */
/*   Updated: 2018/05/01 12:09:47 by mikim            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

/* ************************************************************************** */
/*                                                              Mingyun Kim   */
/*                                           https://www.github.com/mikim42   */
/* ************************************************************************** */

/*                                 Jesse Brown : Mingyun Kim : Victor Sanchez */

#include <iostream> //Allows use of cin and cout

extern "C" void	_asmMain(); //Declare asm main

extern "C" void	_printString(char *s) //In asm a string is an array of char, so we print a char pointer
{
	std::cout << s << std::endl; //Prints with newline
}

extern "C" void	_printStringN(char *s) //Same as _printString but prints without newline
{
	std::cout << s; //Prints without newline
}

extern "C" char	*_getString(void) //Gets userinput and returns a char pointer
{
	std::string s; //Declare string s

	getline(std::cin, s); //Get the whole input
	return (char*)s.c_str(); //Convert string into C string and then to char pointer
}

int		main(void)
{
	_asmMain(); //Call asm main
	return (0); //End of program
}
