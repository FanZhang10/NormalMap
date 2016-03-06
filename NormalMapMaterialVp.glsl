#version 400

// Attributes passed automatically by OGRE
in vec3 vertex;
in vec3 normal;
in vec3 tangent;
in vec4 colour;
in vec2 uv0;

// Attributes passed with the material file
uniform mat4 world_mat;
uniform mat4 view_mat;
uniform mat4 projection_mat;
uniform mat4 normal_mat;
uniform vec3 light_position;

// Attributes forwarded to the fragment shader
out vec3 vertex_position;
out vec3 vertex_normal;
out vec4 vertex_colour;
out vec2 vertex_uv;
out mat3 TBN_mat;
out vec3 light_pos;

void main()
{
    gl_Position = projection_mat * view_mat * world_mat * vec4(vertex, 1.0);

	// Do not apply projection to "vertex_position"
    vertex_position = vec3(view_mat * world_mat * vec4(vertex, 1.0));
	
	// Define vertex tangent, bitangent and normal (TBN)
	// These are used to create the tangent space transformation matrix
	vertex_normal = vec3(normal_mat * vec4(normal, 0.0));
	vec3 vertex_tangent_ts = vec3(normal_mat * vec4(tangent, 0.0));
	vec3 vertex_bitangent_ts = cross(vertex_normal, vertex_tangent_ts);

	// Send tangent space transformation matrix to the fragment shader
	TBN_mat = transpose(mat3(vertex_tangent_ts, vertex_bitangent_ts, vertex_normal));

	light_pos = vec3(view_mat * vec4(light_position, 1.0));

    vertex_colour = colour;
		
	vertex_uv = uv0; 
}