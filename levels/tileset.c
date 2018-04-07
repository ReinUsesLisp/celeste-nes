#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL.h>

int main(int argc, char **argv)
{
	if (argc != 3) return 1;

	SDL_Surface *src = IMG_Load(argv[2]);
	
	// first count lines
	FILE *file = fopen(argv[1], "r");
	int tiles_count = -1; // skip first one
	char *line = NULL;
	size_t line_len = 0;
	while (getline(&line, &line_len, file) != -1)
		tiles_count++;
	rewind(file);

	// allocate output bits
	Uint32 rmask, gmask, bmask;
#if SDL_BYTEORDER == SDL_BIG_ENDIAN
    rmask = 0xff000000;
    gmask = 0x00ff0000;
    bmask = 0x0000ff00;
#else
    rmask = 0x000000ff;
    gmask = 0x0000ff00;
    bmask = 0x00ff0000;
#endif
	SDL_Surface *dest = SDL_CreateRGBSurface(0, 8*16,
			(tiles_count / 8 + 1)*16, 24, rmask, gmask, bmask, 0);

	FILE *out = fopen("tileset.bin", "wb");
	uint32_t zero = 0x64646464;
	fwrite(&zero, 4, 1, out);
	
	// read contents
	int index = 1;
	getline(&line, &line_len, file);
	while (getline(&line, &line_len, file) != -1)
	{
		int ts[4];
		sscanf(line, "%X,%X,%X,%X", ts, ts+1, ts+2, ts+3);
		fwrite(ts+0, 1, 1, out);
		fwrite(ts+1, 1, 1, out);
		fwrite(ts+2, 1, 1, out);
		fwrite(ts+3, 1, 1, out);

		int index_x = index % 8;
		int index_y = index / 8;
		int i;
		for (i = 0; i < 4; i++)
		{
			int t = ts[i];
			SDL_Rect src_rect = { (t % 16)*8, (t / 16)*8, 8, 8 };
			SDL_Rect dest_rect = {
				index_x * 16 + (i % 2) * 8,
				index_y * 16 + (i / 2) * 8,
				8,
				8
			};

			SDL_BlitSurface(src, &src_rect, dest, &dest_rect);
		}
		index++;
	}

	fclose(out);
	fclose(file);
	if (line) free(line);

	IMG_SavePNG(dest, "tileset.png");
	SDL_FreeSurface(dest);
	SDL_FreeSurface(src);

	return 0;
}

