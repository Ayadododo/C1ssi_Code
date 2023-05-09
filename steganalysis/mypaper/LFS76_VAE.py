import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from torch.utils.data import DataLoader, TensorDataset
from sklearn.preprocessing import StandardScaler
import numpy as np
import pandas as pd

# Load the dataset and perform standardization
csv_name = '760MRS128L0.1T3_76mrs0.03.csv'
lfs = pd.read_csv(csv_name)
lfs = lfs.drop(['is_Stego'], axis=1)
dataset = lfs.values
scaler = StandardScaler()
x_train = scaler.fit_transform(dataset)
x_train = torch.Tensor(x_train)

# Define the batch size and data loader
batch_size = 32
train_loader = DataLoader(TensorDataset(x_train), batch_size=batch_size, shuffle=True)

# Define the VAE architecture
class VAE(nn.Module):
    def __init__(self, input_size, hidden_size, latent_size):
        super(VAE, self).__init__()
        self.input_size = input_size
        self.hidden_size = hidden_size
        self.latent_size = latent_size

        # Encoder layers
        self.fc1 = nn.Linear(input_size, hidden_size)
        self.fc21 = nn.Linear(hidden_size, latent_size)
        self.fc22 = nn.Linear(hidden_size, latent_size)

        # Decoder layers
        self.fc3 = nn.Linear(latent_size, hidden_size)
        self.fc4 = nn.Linear(hidden_size, input_size)

    def encode(self, x):
        h1 = F.relu(self.fc1(x))
        return self.fc21(h1), self.fc22(h1)

    def reparameterize(self, mu, logvar):
        std = torch.exp(0.5 * logvar)
        eps = torch.randn_like(std)
        return mu + eps * std

    def decode(self, z):
        h3 = F.relu(self.fc3(z))
        return torch.sigmoid(self.fc4(h3))

    def forward(self, x):
        mu, logvar = self.encode(x.view(-1, self.input_size))
        z = self.reparameterize(mu, logvar)
        return self.decode(z), mu, logvar

# Instantiate the VAE model
input_size = 76
hidden_size = 64
latent_size = 16
model = VAE(input_size, hidden_size, latent_size)

# Define the optimizer and the loss function
optimizer = optim.Adam(model.parameters(), lr=1e-3)
mse_loss = nn.MSELoss(reduction='mean')

# Train the model
num_epochs = 1000
for epoch in range(num_epochs):
    for batch_idx, data in enumerate(train_loader):
        x = data[0]
        optimizer.zero_grad()

        # Forward pass
        recon_x, mu, logvar = model(x)

        # Compute the loss
        recon_loss = mse_loss(recon_x, x)
        kl_div = -0.5 * torch.sum(1 + logvar - mu.pow(2) - logvar.exp())
        loss = recon_loss + kl_div

        # Backward pass and optimization
        loss.backward()
        optimizer.step()

        # Print the training progress
        if batch_idx % 50 == 0:
            print('Epoch {} [{}/{} ({:.0f}%)]\tLoss: {:.6f}'.format(
                epoch+1, batch_idx * len(x), len(train_loader.dataset),
                100. * batch_idx / len(train_loader), loss.item()))

# Generate new samples
# Generate samples from the learned distribution
z = torch.randn(10, latent_size)
samples = model.decode(z)

# Denormalize the generated samples
samples = scaler.inverse_transform(samples.detach().numpy())
print(samples)

# # Save the generated samples to a CSV file
# np.savetxt('generated_samples.csv', samples, delimiter=',')