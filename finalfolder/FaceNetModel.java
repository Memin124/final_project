import org.tensorflow.Graph;
import org.tensorflow.Session;
import org.tensorflow.Tensor;
import org.tensorflow.TensorFlow;
import org.tensorflow.Graph;
import org.tensorflow.Session;
import org.opencv.core.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.core.CvType;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.io.IOException;
import java.nio.FloatBuffer;
import java.nio.ByteBuffer;
import java.io.File;
import java.util.Scanner;
import java.util.*;
import java.io.*;

public class FaceNetModel {
  private String modelPath;
  private Graph graph;
  private Session session;
  private HashMap<String, float[]> faceDb;

  public FaceNetModel(String modelPath) {
    this.modelPath = modelPath;
  }

  public void loadModel() {
    try {
        // Initialize the graph
        this.graph = new Graph();

        // Import the graph definition file (the .pb file)
        byte[] graphBytes = Files.readAllBytes(Paths.get(modelPath));
        graph.importGraphDef(graphBytes);

        // Initialize a new TensorFlow session using the imported graph
        this.session = new Session(graph);

    } catch (IOException e) {
        System.out.println("Failed to load model from path: " + modelPath);
        e.printStackTrace();
    }
  }





    public float[] getFaceEmbedding(Mat face) {  
        float[] embedding = null;  
        try (Tensor<Float> tensor = normalizeImage(face)) {  
            Tensor<Float> output = session.runner()  
                    .feed("input", tensor)  
                    .fetch("Bottleneck_BatchNorm/batchnorm/add_1")  
                    .run()  
                    .get(0)  
                    .expect(Float.class);  
            embedding = new float[(int) output.shape()[1]];  
            output.copyTo(embedding);  
        } catch (Exception e) {  
            e.printStackTrace();  
        }  
        return embedding;  
    }  
  
    private Tensor<Float> normalizeImage(Mat mat) {  
        Imgproc.cvtColor(mat, mat, Imgproc.COLOR_BGR2RGB);  
        mat.convertTo(mat, CvType.CV_32F);
        FloatBuffer fb = convertMatToFloatBuffer(mat); 
        return Tensor.create(new long[]{1, 160, 160, 3}, fb);  
    } 

  public static FloatBuffer convertMatToFloatBuffer(Mat mat) {
        int bufferSize = (int) (mat.total() * mat.channels());
        FloatBuffer floatBuffer = ByteBuffer.allocateDirect(bufferSize * Float.BYTES).asFloatBuffer();
        float[] data = new float[bufferSize];
        mat.get(0, 0, data);
        floatBuffer.put(data);
        floatBuffer.rewind();
        return floatBuffer;
    }
}
