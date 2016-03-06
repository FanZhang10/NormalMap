#version 400

// Attributes passed from the vertex shader
in vec3 vertex_position;
in vec3 vertex_normal;
in vec4 vertex_colour;
in vec2 vertex_uv;
in mat3 TBN_mat;
in vec3 light_pos;

// Attributes passed with the material file
uniform vec4 object_colour;
uniform sampler2D normal_map;

void main() 
{

    // Blinn–Phong shading

    vec3 N, // Interpolated normal for fragment
	     L, // Light-source direction
		 V, // View direction
		 H; // Half-way vector

	// Get substitute normal in tangent space from the normal map
	vec2 coord = vertex_uv;
	coord.y = 1.0 - coord.y;
	N = normalize(texture2D(normal_map, coord).rgb*2.0 - 1.0);

	// Work in tangent space by multiplying our vectors by TBN_mat	
    L = TBN_mat * (light_pos - vertex_position);
    L = normalize(L);
	
	float lambertian = max(dot(N, L), 0.0);

	//V = TBN_mat * (eye_position - vertex_position);
	V = TBN_mat * (- vertex_position); // We already applied the view matrix, so the camera is at the origin
	V = normalize(V);
	
    H = 0.5*(V + L);
    H = normalize(H);
    
	float spec_angle = max(dot(N, H), 0.0);
    float specular = pow(spec_angle, 128.0);
	    
	// Assume all components have the same colour but with different weights
	float ambient = 0.4;
	gl_FragColor = (0.25*ambient + 0.5*lambertian + 1.0*specular)*object_colour;
}