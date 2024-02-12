# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rmitache <rmitache@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/30 21:34:07 by aceauses          #+#    #+#              #
#    Updated: 2024/02/12 12:00:41 by rmitache         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #


CC = gcc
CFLAGS = -Wall -Wextra -Werror
NAME = cub3d
LIBFT = libft/libft.a
MLX = MLX42/build/libmlx42.a
GNL = GNL/gnl
#if ubuntu
ifeq ($(shell uname), Linux)
	MLXFLAGS = -lGL -lglfw
else
	MLXFLAGS = -framework OpenGL -framework AppKit -lglfw
endif
OBJS_DIR = obj/

BOLD    := \033[1m./SRC/
RED     := \033[31;1m
GREEN   := \033[32;1m
YELLOW  := \033[33;1m
BLUE    := \033[34;1m
MAGENTA := \033[35;1m
CYAN    := \033[36;1m
WHITE   := \033[37;1m
RESET = \033[;0m

SRC = cub3d.c init.c init_utils.c init_utils2.c colors.c
SRC_OBS = $(addprefix $(OBJS_DIR), $(notdir $(SRC:.c=.o)))

UTILS = utils_1.c \
		src/map_validations/map_validation_1.c \
		src/map_validations/map_values.c \
		src/map_validations/map_walls.c \
		src/map_validations/map_values_utils.c \
		src/map_validations/map_errors.c
UTILS_OBS = $(addprefix $(OBJS_DIR), $(notdir $(UTILS:.c=.o)))

all: $(NAME)

$(MLX):
	@git submodule update --init --recursive
	@cd MLX42 && cmake -B build
	@cd MLX42 && cmake --build build -j4

$(LIBFT):
	@make -C libft all

$(GNL):
	@make -C GNL

$(OBJS_DIR)%.o: %.c
	@$(CC) $(CFLAGS) -c $< -o $@

$(OBJS_DIR)%.o: src/map_validations/%.c
	@mkdir -p $(OBJS_DIR)
	@echo "$(CYAN)[CUB3D] $(GREEN)Compiling: $(RESET)$(notdir $<)"
	@$(CC) $(CFLAGS) -c $< -o $@

$(OBJS_DIR)%.o: src/%.c
	@mkdir -p $(OBJS_DIR)
	@echo "$(CYAN)[CUB3D] $(GREEN)Compiling: $(RESET)$(notdir $<)"
	@$(CC) $(CFLAGS) -c $< -o $@

$(NAME): $(MLX) $(UTILS_OBS) $(SRC_OBS) $(LIBFT) $(GNL)
	@$(CC) $(CFLAGS) $(SRC_OBS) $(UTILS_OBS) $(MLX) $(LIBFT) $(GNL) $(MLXFLAGS) -o $(NAME)
	@echo "$(CYAN)[CUB3D] $(GREEN)Cub3D Compiled$(RESET)"

NoMlx: $(UTILS_OBS) $(SRC_OBS) $(LIBFT) $(GNL)
	@$(CC) $(CFLAGS) $(SRC_OBS) $(UTILS_OBS) $(LIBFT) $(GNL) -o $(NAME)
	@echo "$(CYAN)[CUB3D] $(GREEN)Cub3D Compiled$(RESET)"

clean:
	@rm -rf $(OBJS_DIR)
	@make -C libft clean
	@make -C GNL clean

fclean: clean
	@rm -rf $(NAME)
	@make -C libft fclean
	@make -C GNL fclean

re: fclean all
