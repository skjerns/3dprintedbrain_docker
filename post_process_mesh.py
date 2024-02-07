import pymeshlab
import sys
import os

# Load input STL files
input_folder = sys.argv[1]
files = ['cortical.stl', 'subcortical.stl']

ms = pymeshlab.MeshSet()
for file in files:
    print(f'loading {file}')

    ms.load_new_mesh(f'{input_folder}/{file}')

print('merge meshes')
ms.apply_filter('flatten_visible_layers', mergevisible=True)
print('closing holes')
ms.apply_filter('merge_close_vertices', )
print('smoothing surfaces')
ms.apply_filter('scaledependent_laplacian_smooth', stepsmoothnum=100, delta=pymeshlab.Percentage(0.1))
print('decimate number of vertices')
ms.apply_filter('simplification_quadric_edge_collapse_decimation', targetfacenum = 290000)

# Save the combined mesh
# try to decimate the mesh until the file size is smaller than 5
print('saving final.stl')
ms.save_current_mesh(f'{input_folder}/final.stl')

while os.path.getsize(f'{input_folder}/final.stl')>25*1000**2:
    size = os.path.getsize(f'{input_folder}/final.stl')
    print(f'size is {size/(1024**2):.1f}MB > 25 MB, decimating by 10%')
    ms.apply_filter('simplification_quadric_edge_collapse_decimation', targetperc=0.9)
    ms.save_current_mesh(f'{input_folder}/final.stl')
