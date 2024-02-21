#include "../includes/cub3d.h"
#include "../includes/struct.h"

void	get_colors(char *argv, char ***floor_colors, char ***ceiling_colors)
{
	int		fd;
	char	*line;

	fd = open_fd(argv);
	line = get_next_line(fd);
	while (line != NULL)
	{
		if (line[0] == 'F' && line[1] == ' ')
			*floor_colors = ft_split(line + 2, ',');
		else if (line[0] == 'C' && line[1] == ' ')
			*ceiling_colors = ft_split(line + 2, ',');
		free(line);
		line = get_next_line(fd);
	}
	free(line);
	close(fd);
}

void	get_window_size(char *argv, size_t	*height, size_t	*width)
{
	int		fd;
	char	*line;
	int		i;

	fd = open_fd(argv);
	line = get_next_line(fd);
	*height = 0;
	*width = 0;
	while (line != NULL)
	{
		i = 0;
		while (line[i] == ' ' || line[i] == '\t')
			i++;
		if (line[i] == '1' || line[i] == '0')
		{
			*height += 1;
			if (ft_strlen(line) > *width)
				*width = ft_strlen(line);
		}
		free(line);
		line = get_next_line(fd);
	}
	free(line);
	close(fd);
}

void	set_angle_from_char(char c, t_player *player)
{
	if (c == 'N')
		player->angle = degToRad(270);
	if (c == 'E')
		player->angle = degToRad(0);
	if (c == 'S')
		player->angle = degToRad(90);
	if (c == 'W')
		player->angle = degToRad(180);
}

void	get_p_pos(char ***map, double *x, double *y, t_player *player)
{
	int		i;
	int		j;

	i = 0;
	*x = 0;
	*y = 0;
	while ((*map)[i] != NULL)
	{
		j = 0;
		while ((*map)[i][j] != '\0')
		{
			if ((*map)[i][j] == 'N' || (*map)[i][j] == 'S' ||
					(*map)[i][j] == 'E' || (*map)[i][j] == 'W')
			{
				*y = i * 64.0;
				*x = j * 64.0;
				set_angle_from_char((*map)[i][j], player);
				return ;
			}
			j++;
		}
		i++;
	}
}
