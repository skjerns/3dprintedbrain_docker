import pymeshlab
import argparse
import sys
import os

# Set up argument parser
parser = argparse.ArgumentParser(description="Process mesh with optional smoothing and decimation")
parser.add_argument('input_folder', type=str, help='Path to the input folder containing STL files')
parser.add_argument('--smooth', type=int, default=100, help='Number of smoothing steps, 0 or False to disable')
parser.add_argument('--decimate', type=float, nargs='?', const=1, default=290000, help='Target number of faces or decimation percentage. Use 1, 0, or False to disable decimation')

# Parse arguments
args = parser.parse_args()

ms = pymeshlab.MeshSet()

print(f'loading lizard brain')
ms.load_new_mesh(f'{args.input_folder}/subcortical.stl')

if args.smooth and args.smooth != 0:
    print(f'smoothing surfaces with {args.smooth} steps')
    ms.apply_filter('scaledependent_laplacian_smooth', stepsmoothnum=args.smooth, 
    delta=pymeshlab.Percentage(0.1))
else:
    print('no smoothing requested')

print(f'loading neocortex')
ms.load_new_mesh(f'{args.input_folder}/cortical.stl')
    
print('merge meshes')
ms.apply_filter('flatten_visible_layers', mergevisible=True)

print('closing holes')
ms.apply_filter('merge_close_vertices', )  


        
if args.decimate not in [1, 0, False]:
    if args.decimate < 1:  # Treat as percentage
        print(f'decimating mesh to {args.decimate} percentage of original')
        ms.apply_filter('simplification_quadric_edge_collapse_decimation', targetperc=args.decimate, preserveboundary=True, boundaryweight=2)
    else:  # Treat as target face number
        print(f'decimating mesh to {args.decimate} faces')
        ms.apply_filter('simplification_quadric_edge_collapse_decimation', targetfacenum=int(args.decimate), preserveboundary=True, boundaryweight=2)
else:
    print('no decimation requested')


# Save the combined mesh
# try to decimate the mesh until the file size is smaller than 5
print('saving final.stl')
ms.save_current_mesh(f'{args.input_folder}/final.stl')