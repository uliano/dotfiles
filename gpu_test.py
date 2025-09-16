#!/usr/bin/env python3
"""
PyTorch GPU Test Program
Tests CUDA functionality with PyTorch on NVIDIA GTX 1080
"""

import torch
import torch.nn as nn
import torch.optim as optim
import numpy as np
import matplotlib.pyplot as plt
import time
from datetime import datetime

def check_cuda_setup():
    """Check and display CUDA setup information"""
    print("=== PyTorch CUDA Setup Check ===")
    print(f"PyTorch Version: {torch.__version__}")
    print(f"CUDA Available: {torch.cuda.is_available()}")

    if torch.cuda.is_available():
        print(f"CUDA Version: {torch.version.cuda}")
        print(f"cuDNN Version: {torch.backends.cudnn.version()}")
        print(f"Number of CUDA devices: {torch.cuda.device_count()}")

        for i in range(torch.cuda.device_count()):
            props = torch.cuda.get_device_properties(i)
            print(f"GPU {i}: {props.name}")
            print(f"  Memory: {props.total_memory / 1024**3:.1f} GB")
            print(f"  Compute Capability: {props.major}.{props.minor}")
            print(f"  Multiprocessors: {props.multi_processor_count}")

        # Set device
        device = torch.device('cuda')
        print(f"Using device: {device}")
        return device
    else:
        print("CUDA not available, using CPU")
        return torch.device('cpu')

def matrix_operations_test(device, size=5000):
    """Test basic GPU matrix operations"""
    print(f"\n=== Matrix Operations Test (size: {size}x{size}) ===")

    # Create random matrices
    print("Creating random matrices...")
    a = torch.randn(size, size, device=device)
    b = torch.randn(size, size, device=device)

    # Matrix multiplication
    print("Performing matrix multiplication...")
    start_time = time.time()
    c = torch.mm(a, b)
    torch.cuda.synchronize() if device.type == 'cuda' else None
    end_time = time.time()

    print(f"Matrix multiplication completed in {end_time - start_time:.4f} seconds")
    print(f"Result shape: {c.shape}")
    print(f"Result mean: {c.mean().item():.6f}")

    # Element-wise operations
    print("Performing element-wise operations...")
    start_time = time.time()
    d = torch.sin(a) + torch.cos(b) * torch.exp(torch.abs(a - b))
    torch.cuda.synchronize() if device.type == 'cuda' else None
    end_time = time.time()

    print(f"Element-wise operations completed in {end_time - start_time:.4f} seconds")
    return c, d

class SimpleNN(nn.Module):
    """Simple neural network for testing"""
    def __init__(self, input_size, hidden_size, output_size):
        super(SimpleNN, self).__init__()
        self.fc1 = nn.Linear(input_size, hidden_size)
        self.relu1 = nn.ReLU()
        self.fc2 = nn.Linear(hidden_size, hidden_size)
        self.relu2 = nn.ReLU()
        self.fc3 = nn.Linear(hidden_size, output_size)

    def forward(self, x):
        x = self.relu1(self.fc1(x))
        x = self.relu2(self.fc2(x))
        x = self.fc3(x)
        return x

def neural_network_test(device):
    """Test neural network training on GPU"""
    print(f"\n=== Neural Network Training Test ===")

    # Create synthetic dataset
    batch_size = 1024
    input_size = 512
    hidden_size = 256
    output_size = 10
    n_samples = 10000

    print(f"Creating synthetic dataset ({n_samples} samples)...")
    X = torch.randn(n_samples, input_size, device=device)
    y = torch.randint(0, output_size, (n_samples,), device=device)

    # Create model
    print("Creating neural network...")
    model = SimpleNN(input_size, hidden_size, output_size).to(device)
    criterion = nn.CrossEntropyLoss()
    optimizer = optim.Adam(model.parameters(), lr=0.001)

    print(f"Model parameters: {sum(p.numel() for p in model.parameters())}")

    # Training loop
    print("Starting training...")
    epochs = 50
    losses = []

    start_time = time.time()
    for epoch in range(epochs):
        # Mini-batch training
        for i in range(0, len(X), batch_size):
            batch_X = X[i:i+batch_size]
            batch_y = y[i:i+batch_size]

            optimizer.zero_grad()
            outputs = model(batch_X)
            loss = criterion(outputs, batch_y)
            loss.backward()
            optimizer.step()

        losses.append(loss.item())

        if (epoch + 1) % 10 == 0:
            print(f"Epoch [{epoch+1}/{epochs}], Loss: {loss.item():.4f}")

    torch.cuda.synchronize() if device.type == 'cuda' else None
    end_time = time.time()

    print(f"Training completed in {end_time - start_time:.4f} seconds")

    # Test inference
    print("Testing inference...")
    model.eval()
    with torch.no_grad():
        test_input = torch.randn(100, input_size, device=device)
        start_time = time.time()
        predictions = model(test_input)
        torch.cuda.synchronize() if device.type == 'cuda' else None
        end_time = time.time()

    print(f"Inference on 100 samples: {end_time - start_time:.6f} seconds")
    print(f"Predictions shape: {predictions.shape}")

    return losses, model

def memory_usage_test(device):
    """Test GPU memory usage"""
    if device.type == 'cuda':
        print(f"\n=== GPU Memory Usage Test ===")

        # Initial memory
        torch.cuda.empty_cache()
        initial_memory = torch.cuda.memory_allocated(device)
        max_memory = torch.cuda.max_memory_allocated(device)

        print(f"Initial memory: {initial_memory / 1024**2:.2f} MB")

        # Allocate progressively larger tensors
        tensors = []
        for i in range(5):
            size = 1000 * (i + 1)
            tensor = torch.randn(size, size, device=device)
            tensors.append(tensor)

            current_memory = torch.cuda.memory_allocated(device)
            print(f"After allocating {size}x{size} tensor: {current_memory / 1024**2:.2f} MB")

        # Check maximum memory used
        max_memory = torch.cuda.max_memory_allocated(device)
        print(f"Maximum memory used: {max_memory / 1024**2:.2f} MB")

        # Clean up
        del tensors
        torch.cuda.empty_cache()
        final_memory = torch.cuda.memory_allocated(device)
        print(f"After cleanup: {final_memory / 1024**2:.2f} MB")

def benchmark_cpu_vs_gpu():
    """Benchmark CPU vs GPU performance"""
    print(f"\n=== CPU vs GPU Performance Benchmark ===")

    sizes = [1000, 2000, 3000, 4000, 5000]
    cpu_times = []
    gpu_times = []

    for size in sizes:
        print(f"Testing size {size}x{size}...")

        # CPU test
        a_cpu = torch.randn(size, size)
        b_cpu = torch.randn(size, size)

        start_time = time.time()
        c_cpu = torch.mm(a_cpu, b_cpu)
        cpu_time = time.time() - start_time
        cpu_times.append(cpu_time)

        # GPU test
        if torch.cuda.is_available():
            a_gpu = a_cpu.cuda()
            b_gpu = b_cpu.cuda()

            start_time = time.time()
            c_gpu = torch.mm(a_gpu, b_gpu)
            torch.cuda.synchronize()
            gpu_time = time.time() - start_time
            gpu_times.append(gpu_time)

            print(f"  CPU: {cpu_time:.4f}s, GPU: {gpu_time:.4f}s, Speedup: {cpu_time/gpu_time:.2f}x")
        else:
            gpu_times.append(0)
            print(f"  CPU: {cpu_time:.4f}s, GPU: N/A")

    return sizes, cpu_times, gpu_times

def create_performance_plot(sizes, cpu_times, gpu_times):
    """Create performance comparison plot"""
    plt.figure(figsize=(10, 6))
    plt.plot(sizes, cpu_times, 'b-o', label='CPU', linewidth=2)
    if torch.cuda.is_available():
        plt.plot(sizes, gpu_times, 'r-s', label='GPU', linewidth=2)

    plt.xlabel('Matrix Size (NxN)')
    plt.ylabel('Time (seconds)')
    plt.title('CPU vs GPU Matrix Multiplication Performance')
    plt.legend()
    plt.grid(True, alpha=0.3)
    plt.yscale('log')

    # Save plot
    plt.savefig('/home/test-pytorch/performance_comparison.png', dpi=300, bbox_inches='tight')
    print("Performance plot saved as 'performance_comparison.png'")
    plt.close()

def main():
    """Main test function"""
    print(f"PyTorch GPU Test - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("="*50)

    # Check CUDA setup
    device = check_cuda_setup()

    # Run tests
    try:
        # Matrix operations test
        matrix_operations_test(device)

        # Neural network test
        losses, model = neural_network_test(device)

        # Memory usage test
        memory_usage_test(device)

        # Performance benchmark
        sizes, cpu_times, gpu_times = benchmark_cpu_vs_gpu()

        # Create performance plot
        create_performance_plot(sizes, cpu_times, gpu_times)

        print(f"\n=== Test Summary ===")
        print("✅ All tests completed successfully!")
        print(f"Device used: {device}")

        if device.type == 'cuda':
            print(f"GPU: {torch.cuda.get_device_name(0)}")
            print(f"Final GPU memory: {torch.cuda.memory_allocated(0) / 1024**2:.2f} MB")

        print("\nFiles generated:")
        print("- performance_comparison.png")

    except Exception as e:
        print(f"❌ Error during testing: {e}")
        raise

if __name__ == "__main__":
    main()