from kitty.fast_data_types import Screen, get_options
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    num_tabs = extra_data.num_tabs
    if num_tabs < 1:
        num_tabs = 1

    total_width = screen.columns
    tab_width = total_width // num_tabs
    if is_last:
        tab_width = total_width - before

    opts = get_options()
    if tab.is_active:
        fg = as_rgb(int(opts.active_tab_foreground))
        bg = as_rgb(int(opts.active_tab_background))
    else:
        fg = as_rgb(int(opts.inactive_tab_foreground))
        bg = as_rgb(int(opts.inactive_tab_background))

    screen.cursor.fg = fg
    screen.cursor.bg = bg

    title = f" {index}: {tab.title} "
    if len(title) > tab_width:
        title = title[: tab_width - 1] + "…"
    title = title.center(tab_width)

    screen.draw(title)
    return screen.cursor.x
