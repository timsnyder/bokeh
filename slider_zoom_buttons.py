from bokeh.layouts import column
from bokeh.models import CustomJS, ColumnDataSource, Slider, ZoomInTool, ZoomOutTool, ResetTool
from bokeh.plotting import figure, show, output_file
from bokeh.sampledata.iris import flowers


INITIAL_FACTOR=0.5

zit = ZoomInTool(factor=INITIAL_FACTOR)
zot = ZoomOutTool(factor=INITIAL_FACTOR)
reset = ResetTool()
TOOLS=[zit,zot,reset]

callback = CustomJS(args=dict(zit=zit, zot=zot), code="""
    var f = cb_obj.get('value')
    zit.set('factor',f);
    zot.set('factor',f);
""")

slider = Slider(start=0.1, end=0.9, value=INITIAL_FACTOR, step=.1, title="zoom factor", callback=callback)


colormap = {'setosa': 'red', 'versicolor': 'green', 'virginica': 'blue'}
colors = [colormap[x] for x in flowers['species']]

p = figure(title = "Iris Morphology", tools=TOOLS)
p.xaxis.axis_label = 'Petal Length'
p.yaxis.axis_label = 'Petal Width'

p.circle(flowers["petal_length"], flowers["petal_width"],
         color=colors, fill_alpha=0.2, size=10)

output_file("slider_zoom_buttons.html", title="iris.py zbtns w/ slider example")

layout = column(slider, p)

show(layout)
