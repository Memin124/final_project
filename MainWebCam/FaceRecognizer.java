import org.tensorflow.Graph;
import org.tensorflow.Session;
import org.tensorflow.Tensor;
import org.tensorflow.TensorFlow;
import org.opencv.core.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.core.CvType;
import org.opencv.objdetect.CascadeClassifier;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.io.IOException;
import java.util.*;

public class FaceRecognizer {
  private String modelPath;
  private String dbPath;
  private FaceNetModel faceNetModel;
  private Map<String, float[]> faceDb = new HashMap<>();
  private double threshold = 1.0;

  public FaceRecognizer(String modelPath, String dbPath) {
    this.modelPath = modelPath;
    this.dbPath = dbPath;
  }

  public void loadModelAndDb() {
    faceNetModel = new FaceNetModel(modelPath);
    faceNetModel.loadModel();
    loadFaceDb(dbPath);
  }

  private void loadFaceDb(String dbPath) {
    try {
      List<String> lines = Files.readAllLines(Paths.get(dbPath));
      for (String line : lines) {
        String[] parts = line.split(",");
        String name = parts[0];
        String[] splitParts = parts[1].split(" ");
        float[] embedding = new float[splitParts.length];
        for (int i = 0; i < splitParts.length; i++) {
          embedding[i] = Float.parseFloat(splitParts[i]);
        }
        
        faceDb.put(name, embedding);
      }
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  public String recognizeFaces(Mat frame) {
    Mat gray = new Mat();
    Imgproc.cvtColor(frame, gray, Imgproc.COLOR_BGR2GRAY);

    MatOfRect faces = new MatOfRect();
    CascadeClassifier faceDetector = new CascadeClassifier();
    faceDetector.detectMultiScale(gray, faces);

    for (Rect rect : faces.toArray()) {
      Mat face = new Mat(frame, rect);
      Imgproc.resize(face, face, new Size(160, 160));
      float[] embedding = faceNetModel.getFaceEmbedding(face);
      String name = recognizeFace(embedding);
      if (name != null) {
        return name;
      }
    }
    return null;
  }

  private String recognizeFace(float[] embedding) {
    String name = "Unknown";
    double minDistance = Double.MAX_VALUE;
    for (Map.Entry<String, float[]> entry : faceDb.entrySet()) {
      float[] dbEmbedding = entry.getValue();
      double distance = calculateDistance(embedding, dbEmbedding);
      if (distance < minDistance) {
        minDistance = distance;
        name = entry.getKey();
      }
    }
    if (minDistance > threshold) {
      name = "Unknown";
    }
    return name;
  }

  private double calculateDistance(float[] embedding1, float[] embedding2) {
    double sum = 0.0;
    for (int i = 0; i < embedding1.length; i++) {
      sum += Math.pow(embedding1[i] - embedding2[i], 2);
    }
    return Math.sqrt(sum);
  }
}
message.txt
3 KB
