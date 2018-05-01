# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mikim <mikim@student.42.us.org>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2018/05/01 12:15:54 by mikim             #+#    #+#              #
#    Updated: 2018/05/01 12:32:50 by mikim            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# **************************************************************************** #
#                                                               Mingyun Kim    #
#                                            https://www.github.com/mikim42    #
# **************************************************************************** #

SRC_v1 = Base64_QXdlc29tZQo=.s

SRC_v2 = Base64_QXdlc29tZQo=_2.s\
		 Base64_QXdlc29tZQo=_2.cpp

SRCDIR_v1 = srcs_v1
SRCDIR_v2 = srcs_v2

SRCS_v1 = $(addprefix $(SRCDIR_v1)/, $(SRC_v1))
SRCS_v2 = $(addprefix $(SRCDIR_v2)/, $(SRC_v2))

OBJ_v1 = $(SRC_v1:.s=.o)
OBJDIR_v1 = objs_v1
OBJS_v1 = $(addprefix $(OBJDIR_v1)/, $(OBJ_v1))

CATCH = 
HEADER =
LIB = 

CC = gcc
CXX = g++ -std=c++11
ASM = as
LINKER = ld

GFLAG = -g
CFLAG = -c
WFLAG = -Wall -Wextra -Werror
UNIT = -D UNIT_TEST

NAME_v1 = Base64_QXdlc29tZQo=.v1
NAME_v2 = Base64_QXdlc29tZQo=.v2

.PHONY: all clean fclean re
.SUFFIXES: .s .o

all: $(NAME_v1) $(NAME_v2)

$(OBJDIR_v1)/%.o: $(SRCDIR_v1)/%.s
	@mkdir -p $(OBJDIR_v1)
	@$(ASM) $(GFLAG) $(HEADER) $< -o $@

$(NAME_v1): $(OBJS_v1)
	@$(LINKER) $(LIB) $(OBJS_v1) -o $@
	@echo "[$(@) Created]"

$(NAME_v2): $(SRCS_v2)
	@$(CXX) $(GFLAG) $(HEADER) $(LIB) $(SRCS_v2) -o $@
	@echo "[$(@) Created]"
clean:
	@/bin/rm -rf $(OBJDIR_v1)
	@echo "[Directory Cleaned]"

fclean: clean
	@/bin/rm -f $(NAME_v1)
	@/bin/rm -f $(NAME_v2)
	@echo "[$(NAME_v1) - Deleted]"
	@echo "[$(NAME_v2) - Deleted]"

re: fclean all
