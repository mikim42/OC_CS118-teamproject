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

#include <iostream>

extern "C" void	_asmMain();

extern "C" void	_printString(char *s)
{
	std::cout << s << std::endl;
}

extern "C" void	_printStringN(char *s)
{
	std::cout << s;
}

extern "C" char	*_getString(void)
{
	std::string s;

	getline(std::cin, s);
	return (char*)s.c_str();
}

int		main(void)
{
	_asmMain();
	return (0);
}
