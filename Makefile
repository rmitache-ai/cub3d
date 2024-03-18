# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: aceauses <aceauses@student.42heilbronn.    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/30 21:34:07 by aceauses          #+#    #+#              #
#    Updated: 2024/03/18 20:48:32 by aceauses         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#    Updated: 2024/02/22 13:53:01 by aceauses         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #


CC = gcc
CFLAGS = -Wall -Wextra -Werror
NAME = cub3d
LIBFT = libft/libft.a
MLX = MLX42/build/libmlx42.a
MLXDIR = $(dir $(MLX))
MLXLIB = $(basename $(notdir $(MLX)))
GNL = GNL/gnl
#if ubuntu
ifeq ($(shell uname), Linux)
	MLXFLAGS = -ldl -lglfw -lm -pthread -I MLX42/include -lXext -lX11
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

SRC_DIR = ./
RAYCASTING_DIR = ./src/raycasting/
INIT_DIR = ./src/
MLX_DIR = ./src/
MAP_VALIDATIONS_DIR = src/map_validations/

SRC = $(SRC_DIR)cub3d.c $(INIT_DIR)utils_1.c $(INIT_DIR)controls.c $(INIT_DIR)controls_utils.c
RAYCASTING_SRC = $(RAYCASTING_DIR)raycast_utils.c $(RAYCASTING_DIR)raycast_utils_1.c
INIT_SRC = $(INIT_DIR)init.c $(INIT_DIR)init_utils.c $(INIT_DIR)init_utils2.c $(INIT_DIR)colors.c
MLX_SRC = $(MLX_DIR)mlx.c $(MLX_DIR)mlx_init.c
MAP_VALIDATIONS_SRC = $(MAP_VALIDATIONS_DIR)map_validation_1.c \
					  $(MAP_VALIDATIONS_DIR)map_values.c \
					  $(MAP_VALIDATIONS_DIR)map_walls.c \
					  $(MAP_VALIDATIONS_DIR)map_values_utils.c \
					  $(MAP_VALIDATIONS_DIR)map_errors.c

SRCS = $(SRC) $(INIT_SRC) $(MAP_VALIDATIONS_SRC) $(MLX_SRC) $(RAYCASTING_SRC)
OBJ_FILES = $(addprefix $(OBJS_DIR), $(notdir $(SRCS:.c=.o)))

VPATH = $(SRC_DIR) $(RAYCASTING_DIR) $(INIT_DIR) $(MLX_DIR) $(MAP_VALIDATIONS_DIR)

all: $(NAME)

$(OBJS_DIR)%.o: %.c
	@mkdir -p $(OBJS_DIR)
	@echo "$(CYAN)[CUB3D] $(GREEN)Compiling: $(RESET)$(notdir $<)"
	@$(CC) $(CFLAGS) -c $< -o $@

$(MLX):
	@git submodule update --init --recursive
	@cd MLX42 && cmake -B build
	@cd MLX42 && cmake --build build -j4

$(LIBFT):
	@make -C libft all

$(GNL):
	@make -C GNL

$(NAME): $(MLX) $(OBJ_FILES) $(LIBFT) $(GNL)
	@$(CC) $(CFLAGS) $(OBJ_FILES) $(MLX) $(LIBFT) $(GNL) $(MLXFLAGS) -o $(NAME)
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
	@cd MLX42 && rm -rf build
	@echo "$(CYAN)[MLX42] $(RED)Library Cleaned$(RESET)"
	@make -C libft fclean
	@make -C GNL fclean

re: fclean all
