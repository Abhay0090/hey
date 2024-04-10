import socket
import time
import threading

def send_udp_packets(ip, port, duration, num_threads):
    total_size_bytes = 0
    packets_sent_per_thread = [0] * num_threads

    def send_packets_thread(thread_id):
        nonlocal total_size_bytes
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            bytes_to_send = b'X' * 1200  # 1200 bytes packet size
            start_time = time.time()
            while (time.time() - start_time) < duration:
                sock.sendto(bytes_to_send, (ip, port))
                packets_sent_per_thread[thread_id] += 1
                total_size_bytes += len(bytes_to_send)
                time.sleep(0.01)  # Delay to control the rate of packet sending
        except Exception as e:
            print(f"An error occurred in thread {thread_id}: {e}")
        finally:
            sock.close()

    threads = []
    for i in range(num_threads):
        thread = threading.Thread(target=send_packets_thread, args=(i,))
        thread.start()
        threads.append(thread)

    for thread in threads:
        thread.join()

    total_packets_sent = sum(packets_sent_per_thread)
    total_size_mb = total_size_bytes / (1024 * 1024)  # Convert total size to MB
    print(f"Sent {total_packets_sent} UDP packets, Total size: {total_size_mb:.2f} MB")

if __name__ == "__main__":
    print("Starting UDP packet sender...")

    ip = input("Enter the IP address of the target: ")
    port = int(input("Enter the port number of the target: "))
    duration = int(input("Enter the duration to send UDP packets (in seconds): "))
    num_threads = int(input("Enter the number of threads/concurrent tasks: "))
    
    send_udp_packets(ip, port, duration, num_threads)
    print("UDP packet sending completed.")
