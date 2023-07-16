void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    //When more, the stronger the effect
    float cellSize = 5.0;
    vec2 inputSize = iResolution.xy;
    
    vec2 uv = fragCoord/inputSize;// Get normalized texture coordinates

    vec2 cellPos = floor(fragCoord / cellSize) * cellSize; // Calculate the position of the current cell
    vec4 color = vec4(0.0); // Initialize color to zero


    for (float x = 0.0; x < cellSize; x += 1.0) {
        for (float y = 0.0; y < cellSize; y += 1.0) {
            vec2 samplePos = (cellPos + vec2(x, y)) / inputSize;
            color += texture(iChannel0, samplePos);
        }
    }

    // Divide by the number of pixels in the cell to get the average color
    color /= (cellSize * cellSize);
    

    fragColor = color; // Output the color of the current cell
}