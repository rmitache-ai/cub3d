/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   cub3d.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: aceauses <aceauses@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/01/30 21:34:37 by aceauses          #+#    #+#             */
/*   Updated: 2024/03/14 20:58:52 by aceauses         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */


#include "includes/cub3d.h"

void	leakcheck(void)
{
	system("leaks --list cub3d");
}

int	main(int argc, char **argv)
{
	t_game	*game;

	atexit(leakcheck);
	game = NULL;
	if (argc != 2)
	{
		printf("Error\nWrong number of arguments\n");
		return (0);
	}
	if (map_validation(argv[1]))
	{
		game = init_data(argv[1]);
		if (!game)
			return (1);
		if (!init_mlx(game))
			return (1);
		if (!init_textures(game))
			return (1);
		start_game(game);
		free_game(game);
	}
	else
		return (1);
	return (0);
}