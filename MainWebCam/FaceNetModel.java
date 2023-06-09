import org.tensorflow.Graph;
import org.tensorflow.Session;
import org.tensorflow.Tensor;
import org.tensorflow.TensorFlow;
import org.opencv.core.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.core.CvType;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.io.IOException;
import java.nio.FloatBuffer;


public class FaceNetModel {
  private String modelPath;
  private Graph graph;
  private Session session;

  public FaceNetModel(String modelPath) {
    this.modelPath = modelPath;
  }

  public void loadModel() {
    try {
      graph = new Graph();
      byte[] graphBytes = Files.readAllBytes(Paths.get(modelPath));
      graph.importGraphDef(graphBytes);
      session = new Session(graph);
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  public float[] getFaceEmbedding(Mat face) {
    Mat mat = normalizeImage(face);
    float[][] flattenedMat = new float[(int) mat.total()][mat.channels()];
    mat.get(0, 0, flattenedMat[0]);

    try (Tensor<Float> tensor = Tensor.create(new long[] {1, 160, 160, 3}, FloatBuffer.wrap(flattenedMat[0]))) {
      Tensor<Float> output = session.runner()
                                    .feed("input_1", tensor)
                                    .fetch("Bottleneck_BatchNorm/batchnorm/add_1")
                                    .run()
                                    .get(0)
                                    .expect(Float.class);
      float[][] embedding = new float[1][(int) output.shape()[1]];
      output.copyTo(embedding);
      return embedding[0];
    } catch (Exception e) {
      e.printStackTrace();
    }
    return null;
  }

  private Mat normalizeImage(Mat mat) {
    Imgproc.cvtColor(mat, mat, Imgproc.COLOR_BGR2RGB);
    mat.convertTo(mat, CvType.CV_32F);
    Core.divide(mat, Scalar.all(255.0), mat);
    return mat;
  }
}
